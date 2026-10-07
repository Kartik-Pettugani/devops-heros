# Kubernetes Volumes

## Introduction

Containers are usually temporary. When a container is deleted or recreated, the files stored inside the container can also disappear.

Kubernetes provides different types of volumes to manage storage and share data between containers and Pods.

This document covers:

* emptyDir
* hostPath
* PersistentVolume
* PersistentVolumeClaim
* StorageClass
* Dynamic Provisioning

---

## 1. emptyDir

`emptyDir` is a temporary volume created when a Pod is assigned to a node.

The volume starts empty and can be shared by multiple containers inside the same Pod.

The data exists as long as the Pod exists. If the Pod is deleted, the data stored in the `emptyDir` volume is also deleted.

### Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-demo
spec:
  containers:
    - name: writer
      image: busybox
      command: ["sh", "-c", "echo 'Hello from emptyDir' > /data/message.txt; sleep 3600"]
      volumeMounts:
        - name: shared-data
          mountPath: /data
    - name: reader
      image: busybox
      command: ["sh", "-c", "sleep 5; cat /data/message.txt; sleep 3600"]
      volumeMounts:
        - name: shared-data
          mountPath: /data
  volumes:
    - name: shared-data
      emptyDir: {}
```

Here, both containers mount the same `emptyDir` volume at `/data`.

The writer container creates:

```text
/data/message.txt
```

The reader container can access the same file.

### Practical use cases

`emptyDir` can be useful for:

* Temporary files
* Scratch space
* Sharing temporary data between containers in the same Pod
* Intermediate files created during application processing

### Important point

`emptyDir` is not suitable for important permanent data because the data disappears when the Pod is deleted.

---

## 2. hostPath

`hostPath` mounts a file or directory from the Kubernetes node's filesystem into a Pod.

For example, a Pod can mount a directory from the node:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-demo
spec:
  containers:
    - name: app
      image: nginx
      volumeMounts:
        - name: host-data
          mountPath: /data
  volumes:
    - name: host-data
      hostPath:
        path: /tmp/kubernetes-data
        type: DirectoryOrCreate
```

The directory:

```text
/tmp/kubernetes-data
```

exists on the Kubernetes node.

The container sees it as:

```text
/data
```

### Practical use cases

`hostPath` can be useful for:

* Development
* Testing
* Accessing node-level files
* Single-node Kubernetes experiments

### Limitations

`hostPath` creates a dependency on a particular node.

If a Pod moves to another node, the data may not be available there.

Therefore, `hostPath` is generally not appropriate for production application storage in a multi-node cluster.

---

## 3. PersistentVolume

A PersistentVolume, or PV, is a storage resource available to the Kubernetes cluster.

It represents actual storage that can be used by applications.

A PV can be backed by different storage systems such as:

* Local storage
* NFS
* CSI-based storage
* Cloud storage

Example:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: /tmp/example-pv
    type: DirectoryOrCreate
```

This creates a 1 GiB PersistentVolume.

### Important properties

A PV can define:

```text
capacity
accessModes
storageClassName
persistentVolumeReclaimPolicy
```

The PV is a cluster-level resource.

It is not tied to a particular namespace.

---

## 4. PersistentVolumeClaim

A PersistentVolumeClaim, or PVC, is a request for storage made by a user or application.

Instead of directly using a PersistentVolume, an application normally requests storage using a PVC.

Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 500Mi
```

The application can then use the PVC:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pvc-demo
spec:
  containers:
    - name: app
      image: nginx
      volumeMounts:
        - name: storage
          mountPath: /data
  volumes:
    - name: storage
      persistentVolumeClaim:
        claimName: example-pvc
```

The relationship is:

```text
Application
     |
     v
    PVC
     |
     v
    PV
     |
     v
Actual Storage
```

The PVC is the request, while the PV represents the storage resource.

---

## 5. StorageClass

A StorageClass describes a class of storage that can be provided to applications.

It allows Kubernetes to understand how storage should be provisioned.

A StorageClass can define things such as:

* Provisioner
* Parameters
* Reclaim policy
* Volume binding mode
* Volume expansion support

Example:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: example-storage
provisioner: example.com/provisioner
```

In real Kubernetes environments, the provisioner is normally provided by a storage system or CSI driver.

For example, a cloud provider can have a StorageClass that provisions cloud disks.

---

## 6. Dynamic Provisioning

Without dynamic provisioning, an administrator may need to manually create a PersistentVolume before an application can use storage.

Dynamic provisioning automates this process.

The application creates a PVC:

```text
PVC
 |
 v
StorageClass
 |
 v
Storage Provisioner
 |
 v
PersistentVolume
 |
 v
Storage
```

For example, a PVC can request:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

If the cluster has a suitable default StorageClass, Kubernetes can dynamically create the required PersistentVolume.

### Benefits

Dynamic provisioning:

* Reduces manual storage management
* Automatically creates storage when required
* Makes applications easier to deploy
* Works well with cloud storage and CSI drivers

---

## 7. Comparison

| Type                  | Lifetime              | Main Purpose                                    |
| --------------------- | --------------------- | ----------------------------------------------- |
| emptyDir              | Pod lifetime          | Temporary storage and sharing data inside a Pod |
| hostPath              | Node filesystem       | Development and testing                         |
| PersistentVolume      | Independent of Pod    | Persistent cluster storage                      |
| PersistentVolumeClaim | Request for storage   | Application storage request                     |
| StorageClass          | Cluster configuration | Defines how storage is provided                 |
| Dynamic Provisioning  | Automatic             | Automatically creates storage for PVCs          |

---

## 8. Key Differences

### emptyDir vs hostPath

`emptyDir` is managed for the lifetime of a Pod.

`hostPath` directly uses a directory from the node.

### PV vs PVC

A PersistentVolume represents available storage.

A PersistentVolumeClaim requests storage.

### StorageClass vs PV

A PV represents an actual storage resource.

A StorageClass defines a class of storage and can be used for dynamic provisioning.

### Static vs Dynamic Provisioning

Static provisioning:

```text
Administrator
     |
     v
Create PV
     |
     v
User creates PVC
     |
     v
PVC binds to PV
```

Dynamic provisioning:

```text
User creates PVC
     |
     v
StorageClass
     |
     v
Provisioner
     |
     v
PV created automatically
```

---

## 9. Real-World Example

Consider an e-commerce application.

Temporary files generated while processing an image can use:

```text
emptyDir
```

A development application that needs access to a directory on a local Kubernetes node might use:

```text
hostPath
```

A production database that needs persistent storage can use:

```text
PVC
 |
 v
PV
 |
 v
Cloud or CSI storage
```

A production environment can use a StorageClass so that storage is automatically created whenever a new PVC is requested.

---

## 10. Conclusion

Kubernetes provides different storage mechanisms for different requirements.

`emptyDir` is useful for temporary Pod-level storage.

`hostPath` provides access to storage on a Kubernetes node and is mainly useful for development and testing.

`PersistentVolume` represents persistent storage.

`PersistentVolumeClaim` allows an application to request persistent storage.

`StorageClass` defines different classes of storage.

Dynamic provisioning allows Kubernetes to automatically create persistent storage when a PVC requests it.

The main concept to remember is:

```text
Temporary storage
    |
    +-- emptyDir

Node-specific storage
    |
    +-- hostPath

Persistent storage
    |
    +-- PVC
          |
          +-- PV
                |
                +-- Storage

Automatic storage creation
    |
    +-- StorageClass
          |
          +-- Dynamic Provisioning
```

## References

* Kubernetes Persistent Volumes documentation
* Kubernetes Storage Classes documentation
* Kubernetes Dynamic Volume Provisioning documentation
