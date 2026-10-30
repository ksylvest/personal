---
date: "2014-05-06"
title: Setup Free(ish) SSL/TLS on Heroku for Ruby on Rails (or Any Other Framework)
summary: Configure SSL/TLS On Heroku Using a CDN
tags:
  - heroku
  - ssl
  - tls
  - ruby
  - rails
  - aws
---

**Note**: This article was post was originally published before [CloudFlare](https://www.cloudflare.com/) added free SSL . It is easy to integrate and I switched over all my apps to using it instead of CloudFront.

Heroku's SSL plan isn't cheap ($20 per month or $240 per year plus $49 for a certificate). Thankfully, using a CDN that supports custom SSL/TLS and CNAME aliases as a proxy reduce your costs to near zero. It also has the added benefit of providing a cache layer if desired.

**Disclaimer** Assess your liability and browser requirements whenever making SSL/TLS setup decisions.

**Note** If you are running in an environment without `pbcopy` or `pbpaste` alias them to the `xsel`:

```bash
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
```

## Step 1. Generate Some Certificates

[StartSSL](https://www.startssl.com/) is one of the few certificate authorities that will let you get a free certificate that works in all the browsers. The service is satisfactory for the price (although [RapidSSL](https://www.rapidssl.com) might be a good option if you can afford it).

1. Visit https://www.startssl.com and click **Sign-Up**
2. Fill in your name, address, location, phone, email and click **Continue**
3. Check your inbox and grab the activation code to confirm your account and click **Continue**
4. Install and backup the client certificate (this is how you authenticate so make sure you save the certificate somewhere safe) and click **Continue**

Now that you have an account open your terminal and run:

```bash
openssl genrsa 2048 > private.pem
openssl req -new -key private.pem -out csr.pem -subj '/CN=ksylvest.com/O=Kevin Sylvestre/C=US/ST=California'
pbcopy < csr.pem
```

Then from your browser (everything you need is copied to your clipboard) go:

1. Visit https://www.startssl.com and click **Authenticate**
2. Click "Certificates Wizard"
3. Select **Web Server SSL/TLS Certificate** and click **Continue**
4. Since you've already generate your key click **Skip**
5. Paste your clipboard into the field and click **Continue**
6. Select your domain and click **Continue**
7. Add in a subdomain (www) and click **Continue**
8. Click **Continue**
9. Copy the field into your clipboard and click **Finish**

Then from your terminal again run:

```bash
pbpaste > ssl.crt
```

Then from your browser go to **Tool Box** and **StartCom CA Certificates** and download **StartCom Root CA (PEM encoded)** as _ca.pem_ and **Class 1 Intermediate Server CA** as _sub.class1.server.ca.pem_. Once the files download run:

```bash
cat sub.class1.server.ca.pem ca.pem > bundle.pem
```

## Step 2. Setup AWS and Upload the Certificates

One great option as a proxy CDN is [Amazon Web Service's (AWS)](https://aws.amazon.com/) [Cloud Front (CF)](https://aws.amazon.com/cloudfront/). Get started by creating an account and authenticating. Then install the [AWS Command Line Interface (CLI)](https://aws.amazon.com/cli/) using:

```bash
brew install awscli
```

Once you've installed the interface use the [Access Key ID and Secret Access Key](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html) from your account and authorize the CLI. Then:

```bash
aws iam upload-server-certificate --server-certificate-name ksylvest --certificate-body file://ssl.crt --private-key file://private.pem --certificate-chain file://bundle.pem --path /cloudfront/
```

Now create a new Cloud Front distribution with the following settings:

- Method: **Web**
- Origin Domain Name: **ksylvest.herokuapp.com**
- Origin ID: **ksylvest.herokuapp.com**
- Origin Protocol Policy: **HTTP Only**
- Viewer Protocol Policy: **HTTP and HTTPS**
- Allowed HTTP Methods: **GET, HEAD, PUT, POST, PATCH, DELETE, OPTIONS**
- Object Caching: **Use Origin Cache Headers**
- Forward Headers: **All** (or **Whitelist** if you know your headers and cache requirements but always include **Host**).
- Forward Cookies: **All**
- Forward Query Strings: **Yes**
- Smooth Streaming: **No**
- Restrict Viewer Access (Use Signed URLs): **No**
- CNAMEs: ksylvest.com,www.ksylvest.com
- SSL Certificate: **Custom SSL Certificate (stored in AWS IAM)**
- Custom SSL Client Support: **Only Clients that Support Server Name Indication (SNI)**

Once a distribution is created (it can take half an hour) you should be able to access your site using the provided URL. Once the distribution comes into effect simply CNAME desired subdomain. CNAMEs are not supported on 'naked' domains by default so either redirect to _www_ or find a DNS provider that supports them (try [cloudflare](https://www.cloudflare.com) or [dnsimple](https://dnsimple.com/) or [amazon](http://aws.amazon.com/route53/)).

## Step 3. Setup AWS and Upload the Certificates

Lastly once you have tested your certificate under the new proxy you can setup your application to redirect to HTTPS in CloudFront if desired (securing all requests).
