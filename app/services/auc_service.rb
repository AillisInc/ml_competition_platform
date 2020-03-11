class AucService

  def request_data(answer_json, prediction_json)
    answer_data = sort_data("item_id", JSON.parse(answer_json))
    prediction_data = sort_data("item_id", JSON.parse(prediction_json))
    [
        answer_data.map {|answer| answer['label']},
        prediction_data.map {|pred| pred['probability']}
    ]
  end

  def metric_keys
    %w[AUC]
  end

  def metric_for_sota
    'AUC'
  end

  def unique_key
    'item_id'
  end

  def prediction_json_schema

    {
        type: "array",
        items: {
            type: "object",
            properties: {
                item_id: {
                    type: "str"
                },
                probability: {
                    type: "number"
                }
            },
            required: %w(item_id probability)
        }
    }
  end

  def answer_json_schema

    {
        type: "array",
        items: {
            type: "object",
            properties: {
                item_id: {
                    type: "str"
                },
                label: {
                    type: "integer"
                }
            },
            required: %w(item_id label)
        }
    }

  end

  private

  def sort_data(sort_key, data)
    data.sort do |a, b|
      a[sort_key] <=> b[sort_key]
    end
  end

end