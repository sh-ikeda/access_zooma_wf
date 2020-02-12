cwlVersion: v1.0
class: CommandLineTool
label: "gen_zooma_query: Generate a TSV of queries to Zooma from a BioSample JSON file."
doc: "Generate a TSV of queries to Zooma from a BioSample JSON file."

hints:
  DockerRequirement:
    dockerPull: shikeda/access_zooma

baseCommand: [gen_zooma_query]

inputs:
  bsjson:
    type: File
    inputBinding:
      position: 50
  attributes:
    type: string?
    inputBinding:
      position: 1
      prefix: -a
      # expected "cell type,cell line,disease,source name,tissue"
  zooma_query_filename:
    type: string

stdout: $(inputs.zooma_query_filename)

outputs:
  zooma_query:
    type: stdout
