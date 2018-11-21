output "public_ip" {
  description = "The Public IP of the instance"
  value = "${aws_instance.windows.public_ip}"
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value = "${aws_alb.LoadBalancer.dns_name}"
}