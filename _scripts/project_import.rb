models_with_titles = {
  Response => %(
  ).strip.split("\n").map do |t|
                t = t.strip
                t == t.pluralize ? t : [t, t.pluralize]
              end,

  Tech => %(
  ).strip.split("\n").map do |t|
            t = t.strip
            t == t.pluralize ? t : [t, t.pluralize]
          end,

  Diagnosis => %(
  ).strip.split("\n").map do |t|
                 t = t.strip
                 t == t.pluralize ? t : [t, t.pluralize]
               end
}

models_with_titles.each do |model, titles|
  titles.each do |title|
    aliases = nil
    if title.is_a?(Array)
      aliases = title[1..-1].join(', ')
      title = title.first
    end
    definition = model.get_definition(title)
    # r = Faraday.get("https://stephenreid.net/k/daniel/terms/#{URI.encode(title)}")
    # definition = Nokogiri::HTML(r.body).search('p.lead').first.text
    attributes = model.create(title: title, tags: model.to_s.downcase, aliases: aliases, body: definition)
    attributes = model.set_callout(attributes, 'example', 'See also', 'x, y, z')
    attributes = model.set_callout(attributes, 'info', 'Podcasts mentioning this term most frequently', "* x\n* y\n* z")
    model.set_see_also(attributes, Concept.all.map { |c| c[:title] })
  end
end

YOUTUBE_IDS = Transcript.existing_youtube_ids
Transcript.populate(skip_existing: false)

[Tech, Response, Diagnosis].each do |model|
  model.all.each do |attributes|
    mentions = Transcript.mentions(attributes)
    # model.set_see_also(attributes, Concept.all.map { |c| c[:title] })
    model.set_callout(attributes, 'info', 'Podcasts mentioning this term most frequently', mentions.sort_by { |_k, v| -v }[0..2].map { |k, v| "* [[#{k}]] (#{v})" }.join("\n"))
  end
end
