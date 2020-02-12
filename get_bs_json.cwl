cwlVersion: v1.0
class: CommandLineTool
label: "get_bs_json: Get a BioSample JSON file from BioSample API."
doc: "Get a BioSample JSON file from BioSample API."

hints:
  DockerRequirement:
    dockerPull: shikeda/access_zooma

baseCommand: [get_bs_json]

inputs:
  bsid_list:
    type: File
    inputBinding:
      position: 50
  nprocess:
    type: int
    inputBinding:
      position: 1
      prefix: -n
  bsjson_filename:
    type: string

stdout: $(inputs.bsjson_filename)

outputs:
  bsjson:
    type: stdout
  get_bs_json_log:
    type: File
    outputBinding:
      glob: "log.*.txt"
