
data "aws_route53_zone" "capstone_zone" {
  name = "capstone.nilipay.com"

}
resource "aws_route53_record" "instance_records" {
  zone_id = data.aws_route53_zone.capstone_zone.zone_id
  name    = "ansible.${data.aws_route53_zone.capstone_zone.name}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.ansible.public_ip]
}

