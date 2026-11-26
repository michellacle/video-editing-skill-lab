# ThinkSmart research findings used for this repo (2026-11-26)

Source: https://thinksmart.life/research/posts/agent-driven-video-editing/

## What matters for our prototype

1. **Mechanical editing is automatable now**
   - report cites operator-level ~90% editing-time reduction
   - benchmark claim: 10-minute tutorial from 6.5h to 83 minutes

2. **Best architecture for this repo**
   - transcript/timestamp-driven edits
   - deterministic edit decision list (EDL/JSON)
   - FFmpeg execution layer for cuts/captions/reframes/exports
   - validation pass that re-transcribes output and checks brief constraints

3. **Practical tiering from report**
   - Tier 0: auto-cut social tools
   - Tier 1: text-based editing (human in loop)
   - Tier 2: agent-driven FFmpeg + MCP workflow (**our target here**)
   - Tier 3: pro NLE with agent prep (Resolve/Premiere)

4. **Known weak link**
   - transcription quality drives everything
   - use higher-accuracy transcription when audio is noisy

## Immediate backlog for this repo

- Build `brief -> edit-plan.json -> ffmpeg` deterministic pipeline
- Add subtitle burn + sidecar SRT generation from transcript timestamps
- Add acceptance checks (target duration, removed pauses/fillers, output format set)
- Add per-project style presets (hook length, caption style, aspect-ratio set)
