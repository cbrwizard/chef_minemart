cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"

knife[:digital_ocean_client_id] = '5eb13c0f2d2395b8a7682a922c7b6fc3'
knife[:digital_ocean_api_key] = '6f8e2d6d49032b8600132315bff74672'