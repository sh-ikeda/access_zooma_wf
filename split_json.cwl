cwlVersion: v1.0
class: CommandLineTool
label: "split_json: Split JSON file into specified number files."
doc: "split_json: Split JSON file into specified number files."

hints:
  DockerRequirement:
    dockerPull: shikeda/MetaSRA-pipeline

baseCommand: [/app/MetaSRA-pipeline/split_json.sh]

inputs:
  input_file:
    type: File
    inputBinding:
      position: 50
  nsplit:
    type: int
    inputBinding:
      position: 1
      prefix: -n

outputs:
  splitted_jsons:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*json"
