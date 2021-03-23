PHONY: github pudding

github:
	rm -rf docs
	cp -r ssr docs
	git add -A
	git commit -m "update github pages"
	git push

aws-sync:
	aws s3 sync ssr s3://pudding.cool/2021/03/foundation-names --delete --cache-control 'max-age=31536000'

aws-cache:
	aws cloudfront create-invalidation --distribution-id E13X38CRR4E04D --paths '/2021/03/foundation-names*'	

pudding: aws-sync aws-cache