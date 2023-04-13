# a convenience class which combines diagnoses, responses and tech
class Concept
  def self.all
    Tech.all + Response.all + Diagnosis.all
  end

  def self.discover
    stops = STOPS
    Concept.all.each do |c|
      stops << c[:title]
      stops += c[:aliases].split(', ') if c[:aliases]
    end

    text = []
    Transcript.all.each do |t|
      text << t[:body]
    end

    text = text.flatten.join(' ').downcase
    words = text.split(' ')
    word_frequency = words.reject { |a| stops.include?(a) || a.start_with?('[[') || a.end_with?(']]') || a.length < 4 }.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    phrase2_frequency = words.each_cons(2).reject { |a, b| stops.include?("#{a} #{b}") || (a.length < 4 || b.length < 4) || a.start_with?('[[') || a.end_with?(']]') || b.start_with?('[[') || b.end_with?(']]') }.each_with_object(Hash.new(0)) { |word, counts| counts[word.join(' ')] += 1 }

    word_frequency.sort_by { |_w, f| -f }.first(100).each do |w, f|
      puts "#{w} #{f}"
    end
    phrase2_frequency.sort_by { |_w, f| -f }.first(100).each do |w, f|
      puts "#{w} #{f}"
    end
  end
end
