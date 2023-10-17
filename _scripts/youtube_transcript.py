import sys
import xml.etree.ElementTree as ET
from youtube_transcript_api import YouTubeTranscriptApi

video_id = sys.argv[1]
transcript = YouTubeTranscriptApi.get_transcript(video_id)

root = ET.Element("transcript")

for entry in transcript:
    text_element = ET.SubElement(root, "text")
    text_element.text = entry['text']
    text_element.set("start", str(entry['start']))
    text_element.set("dur", str(entry['duration']))

xml_str = ET.tostring(root, encoding='utf-8')
print(xml_str.decode('utf-8'))