import ndio.remote.OCP as OCP
oo = OCP()

public_datasets_and_tokens = oo.get_public_datasets_and_tokens()

out = ["| Dataset | Public Tokens |",
       "|---------|---------------|"]
for dataset, tokens in public_datasets_and_tokens.iteritems():
    tokens_list = ['{}'.format(t) for t in tokens]
    out.append("| **{}** | {} |".format(dataset, '; '.join(tokens_list)))

print "\n".join(out)
