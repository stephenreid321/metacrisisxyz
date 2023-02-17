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

YOUTUBE_IDS = %w[jHxTvvPZUuI] # hv_xBK_XZjw E_cyCuCKQhs eq_gaazINkA 7LqaotiGWjQ hGRNUw559SE _b4qKv1Ctv8 YPJug0s2u4w hUE0Q7lv94k db-Xn2gzGxU tJQac_T_rPo MYCvaVqZebA 0v5RiMdSqwk nQRzxEobWco 9QGrffjOFko GWk-ZpJdRFg 8Es_WTEgZHE _7aIgHoydP8 p4NlLuNj0v8 Z_wPQCU5O6w eh7qvXfGQho Kt4f_gcEnh4 G70qtM66iY8 8XCXvzQdcug 3bxzo79SjpE XQpoGL0yIFE aX5n0DYXnUQ LLgv2QJRYSg fWshjsIrUSI mQstRd7opv4 aNj8UiPgqqQ ya_p4RIorXw ndehWd9N9Z4 ZNcyc_sEtpU _eoB4g3gCmw wO1WVguNQAM _BofVO-4yNc MBcoTHlD8r8 Nkv5mpBA8o4 hKvVdGNzCQk UoHmEYZLqmk R2sIG6l4uU0 zi5-90TnI3Y lls_2tfWcUI ZCOfUYrZJMQ V2wuvrgYyh8 01rVKtbqtnA 0snD5FZCVII rrozCypcUx4 MRV-ESY6Obs qd5vPs9cRYI 8xDgk0uGw_s _Oflv3u0HEA VPAOzlqcGIQ SioR1jgdhnk kTFqnPEyweE Pyy3veuvXVE tQkQrc3Ant4 aZhiwxxn3K8 weZqeVh2Exs Wk2HinTpRwQ E0_j2-pLunY q8mleq4VNm8 2YgNYdL7HTk dGW5J3EbOUY m3VGg2kQWR4 Fl8pGMjM9kM LtbMps1PDFc jUn7_85R0M4 X_7U1ApSzaM VLGjzGbPxVI zpGrU99fAA8 WVEP0zAK-xQ U0YJ0C81n4s IfoPitvLY7c 2fAy18JawYI H0ocPsqBKS4 PKz9TAsqsRo Kep8Fi_rUUI 611ctV-HStQ tNO_3JFLVUc I9I7p1eho3k dtxNgnBw8Ao U1QJtDCCMLA pSQqaclDmZ4 SkItTnRJ_1M 2SopiHEqfRQ uhVArr7R-aU ammJN0yCCbs 4pf38y5rFrE zQ0l56vjTss kbg8nHuNggU A41z7UD3NsU Kr2nhiNCOXo Fj6UjIV2VQQ 2p-GlhLQdY0 MZMSs2SLmSw WRohQKNNuM4 EfNgW-On6hw i6-cc71ALQc QAd9O6a6R5w 9LquQ4GgY5Y ZIV1Uw2VyF8 YcIlDc96Azs tWfyOU07vgE PnrL_9V0QMs tj9RceVQBxc mPHUN18BbNo ztfz5EdYxL0 CElwzOUbsGg ZXHagfNHKws HjChfAJy0g8 1rj9NtQafb8 LmlbhD6LbSA SxS1rIXXaQ4 fowcm7b8Dlw qwILqzrvncQ BWfwZvfaoYA yTSWDnhK-M4 vPSXsOeX6lM 6fWfvO72vAw Cqq840poanw GPumhxH3JHA hV9PJhhqw5w zWpKVTyx8R0 vLwlsQYBQ1w fcgOxHHp_i8 EsvG3zbKGa4 kLJ2QztR3ug Z7-Od0e0gq0 QZ9iRByzUJs 22TrTXZLmmU OLWihHrj6zs qKFY5OflSrc NABTu6VOroc ig-bWt2y1VE IVyq4WpmvRM Xhrr-fJCTWY j6nJmVcx6v8 BIKDNStlnL4 SWEoLn54d4U qxtkUJPg7os K2_1tnGL5eQ JBU06Wswc7c 2HfbPJXHmQM E8cSGX02bqA DcNG-gGxroY a6ejROOyHW0 5Rxhyvyq7ew J9f5tuzzFxY mm9AE-oHlPk kmHyhJdSW5o z2rYFnDx6nQ IqLELspOa7g xreo0fw-4_A nOnyWZMvkg4 jzYOybiP7Dg 2zD0kQB6d0M uEAsKkjDURs 3lil4invvSI jQAhGT0nKkI 9TQHtaRXntQ vPbOyjtv5PU LetPkDGIyy0 ggf4ouFJ2x0 eTeLyBxjX9k T9v0IAFPrm0 U6Fo8Ee0x8Q -WQ7QbJGWRE 1r2TSpSNjDI ib4v9cG_ZA8 0dYoSctj3C8 9psdN65IzOw FschjBcFElk vfKR0Nyp--Q AdlYvrKa16c z7DZCChfmf8 17KFrJj1sMQ iF8R1hJT-24
Transcript.populate(skip_existing: true)

[Tech, Response, Diagnosis].each do |model|
  model.all.each do |attributes|
    mentions = Transcript.mentions(attributes)
    model.set_see_also(attributes, Concept.all.map { |c| c[:title] })
    model.set_callout(attributes, 'info', 'Podcasts mentioning this term most frequently', mentions.sort_by { |_k, v| -v }[0..2].map { |k, v| "* [[#{k}]] (#{v})" }.join("\n"))
  end
end
