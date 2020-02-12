cwlVersion: v1.0
class: CommandLineTool
label: "sort: Sort."
doc: "Sort."

baseCommand: [sort]

inputs:
  input_file:
    type: File
    inputBinding:
      position: 50
  output_filename:
    type: string

stdout: $(inputs.output_filename)

outputs:
  sorted_file:
    type: stdout
