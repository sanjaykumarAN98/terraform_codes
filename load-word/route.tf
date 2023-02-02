resource "aws_route53_zone" "zone" {
  name =  "example.in"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "example.in"
  type    = "A"

  alias {
    name                   = aws_elb.word.dns_name
    zone_id                = aws_elb.word.zone_id
    evaluate_target_health = true
}  
}
