resource "aws_appconfig_application" "app_config_spike" {
  name        = "app-config-spike"
  description = "App Config Spike"
  tags = {
    Name = "app-config-spike"
    Type = "AppConfig Application"
  }
}

resource "aws_appconfig_environment" "app_config_spike_testing" {
  application_id = aws_appconfig_application.app_config_spike.id
  name           = "app-config-spike-testing"
}

resource "aws_appconfig_configuration_profile" "app_config_spike" {
  application_id = aws_appconfig_application.app_config_spike.id
  name           = "app-config-spike"
  location_uri   = "hosted"
}

resource "aws_appconfig_hosted_configuration_version" "app_config_spike" {
  application_id           = aws_appconfig_application.app_config_spike.id
  configuration_profile_id = aws_appconfig_configuration_profile.app_config_spike.configuration_profile_id
  content_type             = "application/json"
  content = jsonencode({
    foo  = "bar",
    thud = "grunt"
  })
}

resource "aws_appconfig_deployment" "app_config_spike" {
  application_id           = aws_appconfig_application.app_config_spike.id
  configuration_profile_id = aws_appconfig_configuration_profile.app_config_spike.configuration_profile_id
  environment_id           = aws_appconfig_environment.app_config_spike_testing.environment_id
  description              = "App Config Spike"
  deployment_strategy_id   = "AppConfig.AllAtOnce"
  configuration_version    = aws_appconfig_hosted_configuration_version.app_config_spike.version_number
}