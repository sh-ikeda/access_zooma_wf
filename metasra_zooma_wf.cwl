cwlVersion: v1.0
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  # Inputs for get_bs_json
  nprocess:
    type: int
  bsid_list:
    type: File
  output_basename:
    type: string

  # Inputs for gen_zooma_query
  attributes:
    type: string?
    default: "cell type,cell line,disease,source name,tissue"

  # Inputs for split_json
  nsplit:
    type: int

outputs:
  bsjson:
    type: File
    outputSource: zooma_wf/bsjson
  get_bs_json_log:
    type: File
    outputSource: zooma_wf/get_bs_json_log
  zooma_query:
    type: File
    outputSource: zooma_wf/zooma_query
  zooma_result:
    type: File
    outputSource: zooma_wf/zooma_result
  splitted_jsons:
    type:
      type: array
      items: File
    outputSource: metasra_wf/splitted_jsons
  metasra_json:
    type: File
    outputSource: metasra_wf/metasra_json
  consensus_tables:
    type:
      type: array
      items: File
    outputSource: consensus/consensus_tables

steps:
  zooma_wf:
    run: zooma_wf.cwl
    in:
      nprocess: nprocess
      output_basename: output_basename
      bsid_list: bsid_list
      attributes: attributes
    out:
      [bsjson, get_bs_json_log, zooma_query, zooma_result]

  metasra_wf:
    run: metasra_wf.cwl
    in:
      nprocess: nprocess
      output_basename: output_basename
      nsplit: nsplit
      bsjson: zooma_wf/bsjson
    out:
      [splitted_jsons, metasra_json]

  consensus:
    run: consensus.cwl
    in:
      metasra_result: metasra_wf/metasra_json
      zooma_result: zooma_wf/zooma_result
      base: output_basename
      consensus_filename:
        valueFrom: $(inputs.base).zooma_metasra_consensus.tsv
      mancheck_filename:
        valueFrom: $(inputs.base).zooma_metasra_mancheck.tsv
      mancheck_all_filename:
        valueFrom: $(inputs.base).zooma_metasra_mancheck_all.tsv
    out:
      [consensus_tables]
