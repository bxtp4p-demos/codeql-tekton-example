# CodeQL Tekton Example

This repository contains an example of how to use CodeQL with Tekton.

## Prerequisites

- A Kubernetes cluster (taken care of for you if you're using this from a [GitHub Codespace]())
- Tekton installed on the cluster (taken care of for you if you're using this from a GitHub Codespace)
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

1. Update the following values in [./tekton/pipelinerun.yaml](./tekton/pipelinerun.yaml)

   ```yaml
   params:
   - name: github-url
      value: github.com
   - name: repository
      value: bxtp4p-demos/codeql-tekton-example
   ```

1. Navigate to the `tekton` directory and add the CodeQL build task and pipeline:

   ```bash
   cd tekton
   kubectl apply -f codeql-build-task.yaml -f pipeline.yaml
   ```

## Running the pipeline

1. Navigate to the `tekton` directory:

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

## GitHub Codespace

If you're using this from a GitHub Codespace, Tekton installed in Minikube.

Minikube may not be started when you first open the Codespace. If this is the case, you can start it with:

```bash
minikube start
```

You can then install and run the pipeline as described above.

### Tekton Dashboard

Tekton Dashboard is installed in the Codespace. You can access it by running:

```bash
kubectl --namespace tekton-pipelines port-forward svc/tekton-dashboard 9097:9097
```

Then open up the `PORTS` tab in the Codespace and click on the link next to `9097`. This will open up the Tekton Dashboard in a new browser tab.