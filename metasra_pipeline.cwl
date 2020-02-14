cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: shikeda/MetaSRA-pipeline

baseCommand: [python3, /app/MetaSRA-pipeline/run_pipeline.py]

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1
      prefix: -f
  output_filename:
    type: string
    inputBinding:
      position: 2
      prefix: -o
  nprocess:
    type: int
    inputBinding:
      position: 3
      prefix: -n

outputs:
  metasra_raw_json:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
