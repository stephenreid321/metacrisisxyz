class Project < MarkdownRecord
  def self.fields
    %w[lastUpdated createdAt id website bannerImg logoImg userGithub projectGithub projectTwitter]
  end

  def self.populate
    r = Faraday.get('https://indexer-grants-stack.gitcoin.co/data/1/rounds/0x8aA06b3b8cAc2970857F4E0fD78F21dc01AAdE94/applications.json')
    projects = JSON.parse(r.body)

    projects.each do |p|
      p = p['metadata']['application']['project']

      body = p['description']
      body = %(<img src="https://ipfs-grants-stack.gitcoin.co/ipfs/#{p['bannerImg']}">\n\n#{body}) if p['bannerImg']
      body = %(<img style="width: 200px" src="https://ipfs-grants-stack.gitcoin.co/ipfs/#{p['logoImg']}">\n\n#{body}) if p['logoImg']

      project = Project.create(
        title: p['title'].gsub('/', '-'),
        tags: 'project',
        lastUpdated: p['lastUpdated'],
        createdAt: p['createdAt'],
        id: p['id'],
        website: p['website'],
        bannerImg: p['bannerImg'],
        logoImg: p['logoImg'],
        userGithub: p['userGithub'],
        projectGithub: p['projectGithub'],
        projectTwitter: p['projectTwitter'],
        body: body
      )

      Project.set_callout(project, 'info', 'Metadata', project.reject { |k, _v| k.in?(%i[title body tags]) }.map { |k, v| "* #{k}: #{v}" }.join("\n"))
    end
  end
end
