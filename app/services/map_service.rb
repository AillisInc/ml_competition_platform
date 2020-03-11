class MapService

  def request_data(answer_json, prediction_json)
    [answer_json, prediction_json]
  end

  def metric_keys
    %w[mAP allAP allAR]
  end

  def metric_for_sota
    'mAP'
  end

  def unique_key
    'image_file_name'
  end

  def answer_json_schema

    {
        type: "array",
        items: {
            type: "object",
            properties: {
                image_file_name: {
                    type: "str"
                },
                annotations: {
                    type: "array",
                    items: {
                        type: "object",
                        properties: {
                            class: {
                                type: "str"
                            },
                            xmin: {
                                type: "number"
                            },
                            ymin: {
                                type: "number"
                            },
                            xmax: {
                                type: "number"
                            },
                            ymax: {
                                type: "number"
                            }
                        },
                        required: %w(class xmin ymin xmax ymax)
                    }

                }
            },
            required: %w(image_file_name annotations)
        }
    }
  end


  def prediction_json_schema

    {
        type: "array",
        items: {
            type: "object",
            properties: {
                image_file_name: {
                    type: "str"
                },
                annotations: {
                    type: "array",
                    items: {
                        type: "object",
                        properties: {
                            class: {
                                type: "str"
                            },
                            conf: {
                                type: "number"
                            },
                            xmin: {
                                type: "number"
                            },
                            ymin: {
                                type: "number"
                            },
                            xmax: {
                                type: "number"
                            },
                            ymax: {
                                type: "number"
                            }
                        },
                        required: %w(class conf xmin ymin xmax ymax)
                    }

                }
            },
            required: %w(image_file_name annotations)
        }
    }
  end

end