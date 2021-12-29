

kubeflow_base:
	# Normally would just pipe kustomize directly into apply, however, I ran into an odd timeout issue
	# where after a few resources applied, kubectl would not be able to to contact the server.  Assuming this
	# is a token issue, so split files individually & ran separate as a quick workaround
	cd deploy/kubeflow && find . -type d -exec kubectl apply -f '{}' \;

delete_base:
	# Normally would just pipe kustomize directly into apply, however, I ran into an odd timeout issue
	# where after a few resources applied, kubectl would not be able to to contact the server.  Assuming this
	# is a token issue, so split files individually & ran separate as a quick workaround
	kubectl delete namespace kubeflow || true
	kubectl delete namespace kubeflow-user-example-com || true
	kubectl delete namespace knative-eventing || true
	kubectl delete namespace knative-serving || true
	kubectl delete namespace istio-system || true
	kubectl delete namespace cert-manager || true
	kubectl delete namespace auth || true
	cd deploy/kubeflow && find . -type d -exec kubectl delete -f '{}' \;


auth:
	@read -p "Enter Login Password for user user@example.com: " login_pass; \
	echo "$$login_pass" | python3 deploy/auth_helper.py | kubectl apply -f -
	kubectl rollout restart deployment dex -n auth

kubeflow_ingress:
	kubectl apply -f deploy/ingress.yaml