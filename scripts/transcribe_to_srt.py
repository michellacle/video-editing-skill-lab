#!/usr/bin/env python3
import argparse, wave
import numpy as np
from faster_whisper import WhisperModel

def ts(seconds: float) -> str:
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = seconds % 60
    return f"{h:02d}:{m:02d}:{s:06.3f}".replace('.', ',')

p = argparse.ArgumentParser()
p.add_argument('--wav', required=True)
p.add_argument('--out', required=True)
p.add_argument('--model', default='base')
args = p.parse_args()

with wave.open(args.wav, 'rb') as w:
    raw = w.readframes(w.getnframes())
    audio = np.frombuffer(raw, dtype=np.int16).astype(np.float32) / 32768.0

model = WhisperModel(args.model, device='cpu')
segments, info = model.transcribe(audio)

idx = 0
lines = []
for seg in segments:
    txt = (seg.text or '').strip()
    if not txt:
        continue
    idx += 1
    lines.append(str(idx))
    lines.append(f"{ts(seg.start)} --> {ts(seg.end)}")
    lines.append(txt)
    lines.append("")

with open(args.out, 'w') as f:
    f.write('\n'.join(lines))
print(f"wrote {args.out} segments={idx} lang={info.language}")
