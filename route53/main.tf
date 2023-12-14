resource "aws_route53_record" "alb_route53" {
  zone_id = var.hostzone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}
