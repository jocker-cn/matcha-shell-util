# frozen_string_literal: true

MODEL_ORDER = {
  "docker" => 100,
  "harbor" => 50,
  "k8s" => 40,
}

class Model

end

def order(k)
  if k == nil
    return 0
  end
  MODEL_ORDER[k]
end