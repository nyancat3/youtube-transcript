from youtube_transcript_api import YouTubeTranscriptApi

def get_transcript(video_url):
    # Extract the video ID from the URL
    video_id = video_url.split("v=")[-1]

    # Retrieve the transcript
    transcript = YouTubeTranscriptApi.get_transcript(video_id)

    # Combine transcript into a single string
    full_transcript = "\n".join([entry['text'] for entry in transcript])

    return full_transcript
