#!/bin/bash

source config.sh

mkdir -p ./prometheus_grafana_files/config_maps

for file in "$DASHBOARDS_DIRECTORY"/*; do
    if [ -f "$file" ]; then

        file_name=$(basename "$file")
        absolute_file_name="${file_name%.*}"
        new_file_name="${file_name%.*}.yaml"
        full_path="$GRAFANA_CONFIG_MAPS_DIRECTORY/$new_file_name"
        echo "" > "$full_path"

        yq eval ".apiVersion = \"v1\"" -i "$full_path"
        yq eval ".kind = \"ConfigMap\"" -i "$full_path"
        yq eval ".metadata.name = \"${absolute_file_name}\"" -i "$full_path"
        yq eval ".metadata.namespace = \"${MONITOR_NAMESPACE}\"" -i "$full_path"
        yq eval ".metadata.labels.grafana_dashboard = \"1\"" -i "$full_path"

        # Add the data section with nodes.json content
        nodes_json_content=$(cat "$file" | sed 's/^/  /')  # Add proper indentation

        nodes_json_content=$(tail -n +2 "$file" | sed 's/^/          /')  # Indent the file content
        first_line=$(head -n 1 "$file")  # Extract the first line

        yaml_content="data:
  nodes.json: |-
        $first_line
            $nodes_json_content"

                echo "$yaml_content" >> "$full_path"

        echo "ConfigMap YAML generated at: $GRAFANA_CONFIG_MAPS_DIRECTORY/$file_name"

    fi
done
