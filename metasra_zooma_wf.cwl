cwlVersion: v1.0
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
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

  # Inputs for split_json
  nsplit:
    type: int

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
  splitted_jsons:
    type:
      type: array
      items: File
    outputSource: split_json/splitted_jsons
  consensus_tables:
    type:
      type: array
      items: File
    outputSource: consensus/consensus_tables

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

  split_json:
    run: split_json.cwl
    in:
      input_file: get_bs_json/bsjson
      nsplit: nsplit
      base: output_basename
    out:
      [splitted_jsons] # array

  metasra_pipeline:
    run: metasra_pipeline.cwl
    scatter: input_file
    in:
      input_file: split_json/splitted_jsons
      base: output_basename
      output_filename:
        valueFrom: $(inputs.base).metasra.raw.json
      nprocess: nprocess
    out:
      [metasra_raw_json] # array

  metasra_postprocess:
    run: metasra_postprocess.cwl
    in:
      input_files: metasra_pipeline/metasra_raw_json
      base: output_basename
      output_filename:
        valueFrom: $(inputs.base).metasra.json
    out:
      [metasra_json]

  consensus:
    run: consensus.cwl
    in:
      metasra_result: metasra_postprocess/metasra_json
      zooma_result: zooma_sort/sorted_file
      base: output_basename
      consensus_filename:
        valueFrom: $(inputs.base).zooma_metasra_consensus.tsv
      mancheck_filename:
        valueFrom: $(inputs.base).zooma_metasra_mancheck.tsv
      mancheck_all_filename:
        valueFrom: $(inputs.base).zooma_metasra_mancheck_all.tsv
    out:
      [consensus_tables]
