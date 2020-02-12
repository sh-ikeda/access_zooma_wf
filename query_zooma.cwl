cwlVersion: v1.0
class: CommandLineTool
label: "query_zooma: Send queries to Zooma API and output the response."
doc: "Send queries to Zooma API and output the response."

hints:
  DockerRequirement:
    dockerPull: shikeda/access_zooma

baseCommand: [query_zooma]

inputs:
  zooma_query:
    type: File
    inputBinding:
      position: 50
  nprocess:
    type: int
    inputBinding:
      position: 1
      prefix: -n
  zooma_result_filename:
    type: string

stdout: $(inputs.zooma_result_filename)

outputs:
  zooma_result:
    type: stdout
