#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:-inputs/source_video_01.mp4}"
OUTDIR="${2:-outputs}"
mkdir -p "$OUTDIR" notes

ffprobe -v error \
  -show_entries format=duration,size,bit_rate \
  -show_entries stream=index,codec_type,codec_name,width,height,avg_frame_rate,sample_rate,channels \
  -of default=noprint_wrappers=1 "$INPUT" > notes/video_01_probe.txt

ffmpeg -y -i "$INPUT" -t 10 \
  -c:v libx264 -preset fast -crf 20 \
  -c:a aac -movflags +faststart \
  "$OUTDIR/video_01_preview_10s.mp4"

ffmpeg -y -i "$INPUT" -vf "scale=-2:1920,crop=1080:1920" \
  -c:v libx264 -preset medium -crf 22 \
  -c:a aac -movflags +faststart \
  "$OUTDIR/video_01_vertical_1080x1920.mp4"

ffmpeg -y -i "$INPUT" -vn -ac 1 -ar 16000 "$OUTDIR/video_01_audio_16k.wav"

ffmpeg -y -i "$INPUT" -vf "fps=1/2,scale=480:-1,tile=4x4" -frames:v 1 \
  "$OUTDIR/video_01_contact_sheet.jpg"

ls -lh "$OUTDIR" > notes/outputs_manifest.txt

echo "Done. See notes/video_01_probe.txt and notes/outputs_manifest.txt"
