module CukeApiHelper

  def item_query_to_json(params={})
    item_query(params)
    JSON.parse(page.source)
  end
  
  def item_query(params={})
    visit("/api/v1/items?#{ params.to_param }")
  end

  def load_dataset
    File.read(File.dirname(__FILE__) + "/../../v1/lib/v1/standard_dataset/items.json")
  end

  def get_maintenance_file
    File.dirname(__FILE__) + "/../../tmp/maintenance.yml"
  end

end

World(CukeApiHelper)