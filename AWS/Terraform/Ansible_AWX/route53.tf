
data "aws_route53_zone" "training_zone" {
  name = "training.nilipay.com"

}
resource "aws_route53_record" "instance_records" {
  zone_id = data.aws_route53_zone.training_zone.zone_id
  name    = "awx.${data.aws_route53_zone.training_zone.name}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.ansible.public_ip]
}

