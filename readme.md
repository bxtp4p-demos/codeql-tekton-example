# CodeQL Tekton Example

This repository contains an example of how to use CodeQL with Tekton.

## Prerequisites

- A Kubernetes cluster
- Tekton installed on the cluster
- A GitHub account with a repository to upload SARIF results to. Make sure GitHub Advanced Security is enabled for the repository.
- A GitHub personal access token with the `security_events` scope

## Setup

1. Fork this repository
1. Install the `git-clone` task:

   ```bash
   kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.6/git-clone.yaml
   ```

1. Create a secret containing your GitHub personal access token:

    ```bash
    kubectl create secret generic github-token --from-literal=token=<your token>
    ```

1. Create a secret containing your ssh key:

   ```bash
   kubectl create secret generic my-ssh-credentials --from-file=<path to private key>
   ```

1. Update the following values in [./pipelinerun.yaml](./pipelinerun.yaml)

   ```yaml
   params:
   - name: github-url
      value: github.com
   - name: repository
      value: bxtp4p-demos/codeql-tekton-example
   ```

1. Add the CodeQL build task and pipeline:

   ```bash
   kubectl apply -f codeql-build-task.yaml -f pipeline.yaml
   ```

## Running the pipeline

Navigate to the `tekton` directory:

```bash
cd tekton
```

Create a pipeline run:

```bash
kubectl create -f pipelinerun.yaml
```

View the logs using [`tkn` cli](https://tekton.dev/docs/cli/):

```bash
tkn pipelinerun logs -f test-codeql-xxxxx
```

You can see the uploaded SARIF results in the GitHub Security tab in the repository you specified for the `repository` parameter.
