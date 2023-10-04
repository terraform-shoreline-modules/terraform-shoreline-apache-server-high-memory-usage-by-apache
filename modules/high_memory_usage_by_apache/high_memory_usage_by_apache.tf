resource "shoreline_notebook" "high_memory_usage_by_apache" {
  name       = "high_memory_usage_by_apache"
  data       = file("${path.module}/data/high_memory_usage_by_apache.json")
  depends_on = [shoreline_action.invoke_apache_memory_monitor,shoreline_action.invoke_modify_apache_config]
}

resource "shoreline_file" "apache_memory_monitor" {
  name             = "apache_memory_monitor"
  input_file       = "${path.module}/data/apache_memory_monitor.sh"
  md5              = filemd5("${path.module}/data/apache_memory_monitor.sh")
  description      = "Identify the root cause of the high memory usage by Apache by analyzing the server logs and monitoring tools."
  destination_path = "/agent/scripts/apache_memory_monitor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "modify_apache_config" {
  name             = "modify_apache_config"
  input_file       = "${path.module}/data/modify_apache_config.sh"
  md5              = filemd5("${path.module}/data/modify_apache_config.sh")
  description      = "Optimize the Apache server configuration by adjusting parameters such as MaxClients, MaxRequestsPerChild, and KeepAliveTimeout to reduce memory usage."
  destination_path = "/agent/scripts/modify_apache_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apache_memory_monitor" {
  name        = "invoke_apache_memory_monitor"
  description = "Identify the root cause of the high memory usage by Apache by analyzing the server logs and monitoring tools."
  command     = "`chmod +x /agent/scripts/apache_memory_monitor.sh && /agent/scripts/apache_memory_monitor.sh`"
  params      = ["PATH_TO_APACHE_LOG_FILE","MEMORY_USAGE_THRESHOLD_IN_MB"]
  file_deps   = ["apache_memory_monitor"]
  enabled     = true
  depends_on  = [shoreline_file.apache_memory_monitor]
}

resource "shoreline_action" "invoke_modify_apache_config" {
  name        = "invoke_modify_apache_config"
  description = "Optimize the Apache server configuration by adjusting parameters such as MaxClients, MaxRequestsPerChild, and KeepAliveTimeout to reduce memory usage."
  command     = "`chmod +x /agent/scripts/modify_apache_config.sh && /agent/scripts/modify_apache_config.sh`"
  params      = ["MAX_CLIENTS","KEEP_ALIVE_TIMEOUT","MAX_REQUESTS_PER_CHILD"]
  file_deps   = ["modify_apache_config"]
  enabled     = true
  depends_on  = [shoreline_file.modify_apache_config]
}

