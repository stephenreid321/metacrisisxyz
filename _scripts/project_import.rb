require_relative 'constants'

models_with_titles = {
  Response => %(
    collective action
    collective intelligence
    complexity science
    dunbar number
    emergent property
    exponential tech
    game b
    network dynamics
    network theory
    nonlinear dynamics
    open society
    open source
    sensemaking
    social tech
    superorganism
    superstructure
    systems thinking
    third attractor
  ).strip.split("\n").map do |t|
                t = t.strip
                t == t.pluralize ? t : [t, t.pluralize]
              end,

  Tech => %(
    artificial intelligence
    blockchain
    liquid democracy
    permaculture
    regenerative agriculture
    web3
  ).strip.split("\n").map do |t|
            t = t.strip
            t == t.pluralize ? t : [t, t.pluralize]
          end,

  Diagnosis => %(
    apex predator
    arms race
    biosecurity
    bretton woods
    catastrophe weapon
    catastrophic risk
    civilizational collapse
    climate change
    confirmation bias
    conflict theory
    coordination failure
    critical infrastructure
    decision making
    dystopia
    embedded growth obligation
    epistemic commons
    existential risk
    existential threat
    exponential growth
    fourth estate
    game theory
    generator function
    global governance
    human nature
    hypernormal stimuli
    materials economy
    metacrisis
    mistake theory
    multipolar trap
    mutually assured destruction
    narrative warfare
    nation state
    nuclear weapon
    paperclip maximizer
    perverse incentive
    plausible deniability
    planetary boundary
    race to the bottom
    rivalrous dynamics
    self-terminating
    social media
    social structure
    social system
    supply chain
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
  end
end

Transcript.populate

[Tech, Response, Diagnosis].each do |model|
  model.all.each do |attributes|
    mentions = Transcript.mentions(attributes)
    model.set_see_also(attributes, Concept.all.map { |c| c[:title] })
    model.set_callout(attributes, 'info', 'Podcasts mentioning this term most frequently', mentions.sort_by { |_k, v| -v }[0..2].map { |k, v| "* [[#{k}]] (#{v})" }.join("\n"))
  end
end
