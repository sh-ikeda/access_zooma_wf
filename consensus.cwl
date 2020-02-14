cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: shikeda/MetaSRA-pipeline

baseCommand: [/app/MetaSRA-pipeline/consensus.awk]

inputs:
  metasra_result:
    type: File
    inputBinding:
      position: 50
  zooma_result:
    type: File
    inputBinding:
      position: 51
  consensus_filename:
    type: string
    inputBinding:
      position: 1
      prefix: -vc=
      separate: false
  mancheck_filename:
    type: string
    inputBinding:
      position: 2
      prefix: -vm=
      separate: false
  mancheck_all_filename:
    type: string
    inputBinding:
      position: 3
      prefix: -va=
      separate: false

outputs:
  consensus_tables:
    type:
      type: array
      items: File
    outputBinding:
      glob: [$(inputs.consensus_filename), $(inputs.mancheck_filename), $(inputs.mancheck_all_filename)]
