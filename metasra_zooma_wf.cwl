cwlVersion: v1.0
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}

inputs:
  # Inputs for get_bs_json
  nprocess:
    type: int
  bsid_list:
    type: File
  bsjson_filename:
    type: string

  # Inputs for gen_zooma_query
  zooma_query_filename:
    type: string
  attributes:
    type: string

  # Inputs for query_zooma
  zooma_result_filename:
    type: string

  # Inputs for sort
  output_filename:
    type: string

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
    outputSource: sort/sorted_file

steps:
  get_bs_json:
    run: get_bs_json.cwl
    in:
      bsid_list: bsid_list
      nprocess: nprocess
      bsjson_filename: bsjson_filename
    out:
      [bsjson, get_bs_json_log]

  gen_zooma_query:
    run: gen_zooma_query.cwl
    in:
      bsjson: get_bs_json/bsjson
      zooma_query_filename: zooma_query_filename
      attributes: attributes
    out:
      [zooma_query]

  query_zooma:
    run: query_zooma.cwl
    in:
      zooma_query: gen_zooma_query/zooma_query
      nprocess: nprocess
      zooma_result_filename: zooma_result_filename
    out:
      [zooma_result]

  sort:
    run: sort.cwl
    in:
      input_file: query_zooma/zooma_result
      output_filename: output_filename
    out:
      [sorted_file]
