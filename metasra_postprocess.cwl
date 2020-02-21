cwlVersion: v1.0
class: CommandLineTool
label: "metasra_postprocess: Concatenates JSON files from multiple metasra_pipeline processes, converts their data into TSV format, and sorts."
doc: "Concatenates JSON files from multiple metasra_pipeline processes, converts their data into TSV format, and sorts."

hints:
  DockerRequirement:
    dockerPull: shikeda/MetaSRA-pipeline

baseCommand: [/app/MetaSRA-pipeline/metasra_postprocess.sh]

inputs:
  input_files:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
  output_filename:
    type: string

stdout: $(inputs.output_filename)

outputs:
  metasra_json:
    type: stdout
