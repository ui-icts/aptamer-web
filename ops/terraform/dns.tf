data "aws_route53_zone" "dns_zone" {
  name          = "icts-aptamer.aws.cloud.uiowa.edu"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.dns_zone.id
  name    = data.aws_route53_zone.dns_zone.name
  type    = "A"
  alias {
    name = aws_lb.app.dns_name
    zone_id = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}

