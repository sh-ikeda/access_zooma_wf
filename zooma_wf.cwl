cwlVersion: v1.0
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}

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

outputs:
  bsjson:
    type: File
    outputSource: get_bs_json/bsjson
  get_bs_json_log:
    type: File
    outputSource: get_bs_json/get_bs_json_log
  zooma_query:
    type: File
    outputSource: gen_zooma_query/zooma_query
  zooma_result:
    type: File
    outputSource: zooma_sort/sorted_file

steps:
  get_bs_json:
    run: get_bs_json.cwl
    in:
      bsid_list: bsid_list
      nprocess: nprocess
      base: output_basename
      bsjson_filename:
        valueFrom: $(inputs.base).bs.json
    out:
      [bsjson, get_bs_json_log]

  gen_zooma_query:
    run: gen_zooma_query.cwl
    in:
      bsjson: get_bs_json/bsjson
      base: output_basename
      zooma_query_filename:
        valueFrom: $(inputs.base).zooma_query.tsv
      attributes: attributes
    out:
      [zooma_query]

  query_zooma:
    run: query_zooma.cwl
    in:
      zooma_query: gen_zooma_query/zooma_query
      nprocess: nprocess
      base: output_basename
      zooma_result_filename:
        valueFrom: $(inputs.base).zooma.unsorted.tsv
    out:
      [zooma_result]

  zooma_sort:
    run: sort.cwl
    in:
      input_file: query_zooma/zooma_result
      base: output_basename
      output_filename:
        valueFrom: $(inputs.base).zooma.tsv
    out:
      [sorted_file]

