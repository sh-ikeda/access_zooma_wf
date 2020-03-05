cwlVersion: v1.0
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  nprocess:
    type: int
  output_basename:
    type: string

  # Inputs for split_json
  nsplit:
    type: int
  bsjson:
    type: File

outputs:
  splitted_jsons:
    type:
      type: array
      items: File
    outputSource: split_json/splitted_jsons
  metasra_raw_json:
    type:
      type: array
      items: File
    outputSource: metasra_pipeline/metasra_raw_json
  metasra_tsv:
    type: File
    outputSource: metasra_postprocess/metasra_tsv

steps:
  split_json:
    run: split_json.cwl
    in:
      input_file: bsjson
      nsplit: nsplit
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
        valueFrom: $(inputs.base).metasra.tsv
    out:
      [metasra_tsv]

