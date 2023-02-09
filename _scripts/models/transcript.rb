require_relative '../constants'

class Transcript < MarkdownRecord
  def self.fields
    %w[tags aliases youtube_id]
  end

  def self.existing_youtube_ids
    all.map { |t| t[:youtube_id] }
  end

  def self.populate
    concepts_with_aliases = Concept.all.map { |c| [c[:title], [c[:title]] + (c[:aliases] ? c[:aliases].split(', ') : [])] }.to_h

    YOUTUBE_IDS.each_with_index do |youtube_id, i|
      puts "#{i + 1}/#{YOUTUBE_IDS.count}"
      puts youtube_id

      if t = Transcript.all.find { |t| t[:youtube_id] == youtube_id }
        title = t[:title]
        puts "found #{title}"
      else
        r = Faraday.get("https://www.youtube.com/watch?v=#{youtube_id}")
        title = CGI.unescapeHTML(r.body.match(%r{<title>(.+)</title>})[1]).force_encoding('UTF-8').gsub('|', '–').gsub('/', ' ').gsub('#', '').gsub(' - YouTube', '')
        puts "fetched #{title}"
      end

      next unless TITLE_REQUIREMENTS.any? { |word| title.match(/#{word}/i) }

      if File.exist?("_transcripts/#{youtube_id}.xml")
        xml = File.read("_transcripts/#{youtube_id}.xml")
      else
        r = Faraday.get("https://youtubetranscript.com/?server_vid=#{youtube_id}")
        xml = r.body
        File.write("_transcripts/#{youtube_id}.xml", xml)
      end

      xml = xml.strip.downcase.gsub('[', '').gsub(']', '')
      body = Nokogiri::XML(xml.gsub('</text><text', '</text> <text')).text

      body = %(<div class="yt-container"><iframe src="https://www.youtube.com/embed/#{youtube_id}"></iframe></div>\n\n#{body})
      transcript = Transcript.create(title: title, tags: 'transcript', youtube_id: youtube_id, body: body)
      transcript = Transcript.tidy(transcript)
      transcript = Transcript.backlink(transcript, concepts_with_aliases)

      Nokogiri::XML(xml).search('transcript').children.each_with_index do |node, i|
        next unless i > 0 && i % 10 == 0 && transcript[:body].scan(node.text).count == 1

        t = node.attributes['start'].value
        transcript[:body].sub!(node.text, "#{node.text} [#{t.split('.').first}](https://www.youtube.com/watch?v=#{youtube_id}&t=#{t}s)\n\n")
      end
      transcript[:body] = transcript[:body].split("\n\n").map { |line| line.strip }.join("\n\n")
      Transcript.update(transcript)
    end
  end

  def self.tidy(transcript)
    body = transcript[:body]
    DASHED_TERMS_TO_UNDASH.each do |term|
      body = body.gsub(/#{term}/i, term.gsub('-', ''))
    end
    SPACED_TERMS_TO_UNSPACE.each do |term|
      body = body.gsub(/#{term}/i, term.gsub(' ', ''))
    end
    SPACED_TERMS_TO_DASH.each do |term|
      body = body.gsub(/#{term}/i, term.gsub(' ', '-'))
    end
    CORRECTIONS.each do |term, correction|
      body = body.gsub(/#{term}/i, correction)
    end
    Transcript.update(title: transcript[:title], body: body)
  end

  def self.backlink(transcript, concepts_with_aliases = Concept.all.map { |c| [c[:title], [c[:title]] + (c[:aliases] ? c[:aliases].split(', ') : [])] }.to_h)
    body = transcript[:body]
    concepts_with_aliases.each do |primary, terms|
      terms.each do |term|
        body.gsub!(/(?<!\[\[)\b#{term}\b(?!\]\])/, primary == term ? "[[#{primary}]]" : "[[#{primary}|#{term}]]")
      end
      transcript = Transcript.update(title: transcript[:title], body: body)
    end
    transcript
  end

  def self.mentions(attributes)
    transcripts = {}
    Transcript.all.each do |t|
      c = t[:body].scan("[[#{attributes[:title]}]]").count
      if attributes[:aliases]
        attributes[:aliases].split(', ').each do |a|
          c += t[:body].scan("[[#{attributes[:title]}|#{a}]]").count
        end
      end
      transcripts[t[:title]] = c if c > 0
    end
    transcripts
  end
end
