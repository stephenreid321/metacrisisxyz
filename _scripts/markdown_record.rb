require_relative 'constants'

class MarkdownRecord
  def self.fields
    %w[tags aliases]
  end

  def self.dir
    to_s.pluralize
  end

  def self.all
    @all = []
    Dir["#{dir}/*.md"].map do |path|
      text = File.read(path)
      yaml = YAML.load(text)
      yaml = yaml.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
      {
        title: path.split('/').last.split('.md').first,
        body: text.split('---')[2..-1].join('---').strip
      }.merge(yaml)
    end
  end

  def self.find_or_create(attributes)
    find(attributes) || create(attributes)
  end

  def self.find_by_title(title)
    all.find { |c| c[:title] == title }
  end

  def self.create(attributes)
    y = fields.map { |f| [f, attributes[f.to_sym]] }.to_h
    File.write("#{dir}/#{attributes[:title]}.md", y.to_yaml + "---\n\n#{attributes[:body]}")
    attributes
  end

  def self.update(new_attributes)
    attributes = find_by_title(new_attributes[:title])
    attributes = attributes.each_with_object({}) { |(k, v), h| h[k] = new_attributes[k] || v }
    create(attributes)
  end

  def self.get_callout(attributes, callout_type, callout_title)
    lines = attributes[:body].split("\n")

    i = lines.index { |line| line.starts_with?("> [!#{callout_type}] #{callout_title}") }
    return unless i

    j = i
    j += 1 while lines[j].starts_with?('> ')

    lines[i..j - 1].join("\n")
  end

  def self.set_callout(attributes, callout_type, callout_title, new_callout)
    lines = attributes[:body].split("\n")

    i = lines.index { |line| line.starts_with?("> [!#{callout_type}] #{callout_title}") }
    if i
      j = i
      j += 1 while lines[j] && lines[j].starts_with?('> ')

      lines[i..j - 1].join("\n")

      lines[i + 1..j - 1] = new_callout.split("\n").map { |line| "> #{line}" }
      body = lines.join("\n")
    else
      body = attributes[:body] + "\n\n> [!#{callout_type}] #{callout_title}\n#{new_callout.split("\n").map { |line| "> #{line}" }.join("\n")}"
    end

    update(title: attributes[:title], body: body)
  end

  def self.get_definition(title)
    body = nil
    until body
      openapi_response = OPENAI.post('completions') do |req|
        req.body = { model: 'text-davinci-003', max_tokens: 1024, prompt:
          "Provide a postgraduate-level definition of the term '#{title}'#{", #{CONTEXT}" if CONTEXT} .

        The definition should be 1 paragraph, maximum 150 words." }.to_json
      end
      puts JSON.parse(openapi_response.body)
      body = JSON.parse(openapi_response.body)['choices'].first['text'].strip if JSON.parse(openapi_response.body)['choices']
    end
    body
  end

  def self.set_see_also(attributes, titles)
    body = nil
    until body
      openapi_response = OPENAI.post('completions') do |req|
        req.body = { model: 'text-davinci-003', max_tokens: 1024, prompt:
          "Select the 5 terms from the list below that are most relevant to the term '#{attributes[:title]}'.

          #{(titles - [attributes[:title]]).join(', ')}.

          Return the result as a comma-separated list, e.g. 'term1, term2, term3, term4, term5'" }.to_json
      end
      puts JSON.parse(openapi_response.body)
      body = JSON.parse(openapi_response.body)['choices'].first['text'].strip if JSON.parse(openapi_response.body)['choices']
    end
    set_callout(attributes, 'example', 'See also', body.gsub('.','').split(', ').map { |t| "[[#{t.downcase}]]" }.join(', '))
  end
end
