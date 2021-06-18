# Hands-on Docker-09 : Docker Swarm Networking, Managing Services, Secrets and Stacks

Purpose of the this hands-on training is to give students the understanding to the Docker Swarm basic operations.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Explain what Docker Swarm cluster is.

- Set up a Docker Swarm cluster.

- Deploy an application as service on Docker Swarm.

- Use `overlay` network in Docker Swarm.

- Update and revert a service in Docker Swarm.

- Create and manage sensitive data with Docker Secrets.

- Create and manage Docker Stacks.

## Outline

- Part 1 - Launch Docker Machine Instances and Connect with SSH

- Part 2 - Set up a Swarm Cluster with Manager and Worker Nodes

- Part 3 - Using Overlay Network in Docker Swarm

- Part 4 - Managing Sensitive Data with Docker Secrets

- Part 5 - Managing Docker Stack
  
- Part 6 - Running WordPress as a Docker Stack

## Part 1 - Launch Docker Machine Instances and Connect with SSH

1. Launch `five` Compose enabled Docker machines on Amazon Linux 2 with security group allowing SSH connections using the of [Clarusway Docker Swarm Cloudformation Template](./clarusway-docker-swarm-cfn-template.yml).

2. Connect to your instances with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

## Part 2 - Set up a Swarm Cluster with Manager and Worker Nodes

3. Prerequisites (Those prerequisites are satisfied within cloudformation template in Part 1)

  - Five EC2 instances on Amazon Linux 2 with `Docker` and `Docker Compose` installed.

  - Set these ingress rules on your EC2 security groups:

    - HTTP port 80 from 0.0.0.0\0

    - TCP port 2377 from 0.0.0.0\0

    - TCP port 8080 from 0.0.0.0\0

    - SSH port 22 from 0.0.0.0\0 (for increased security replace this with your own IP)

4. Initialize `docker swarm` with Private IP and assign your first docker machine as manager:

```bash
docker swarm init
# or
docker swarm init --advertise-addr <Private IPs>
```

5. Check if the `docker swarm` is active or not.

```bash
docker info
```

6. Get the manager token with `docker swarm join-token manager` command.

```bash
docker swarm join-token manager
```

7. Add second and third Docker Machine instances as manager nodes, by connecting with SSH and running the given command above.

```bash
docker swarm join --token <manager_token> <manager_ip>:2377
```

8. Add fourth and fifth Docker Machine instances as worker nodes. (Run `docker swarm join-token worker` command to get join-token for worker, if needed)

```bash
docker swarm join --token <worker_token> <manager_ip>:2377
```

9. List the connected nodes in `Swarm`.

```bash
docker node ls
```

## Part 3 - Using Overlay Network in Docker Swarm

10. List Docker networks and explain overlay network (ingress)

```bash
docker network ls
docker network inspect ingress
```

11. Create a user defined overlay network.

```bash
docker network create -d overlay clarus-net
```

12. Explain user-defined overlay network (clarus-net)

```bash
docker network inspect clarus-net
```

13. Create a new service with 3 replicas.

```bash
docker service create --name webserver --network clarus-net -p 80:80 -d --replicas=3 clarusway/container-info:1.0
```

14. List the tasks of `webserver` service, detect the nodes which is running the task and which is not.

```bash
docker service ps webserver
```

15. Check the URLs of nodes that is running the task with `http://<ec2-public-hostname-of-node>` in the browser and show that the app is accessible, and explain `Container Info` on the app page. (`Host` is the name of container hosting the app, `Network Information` is giving IP addresses attached to `container` by different networks, for example;  `10.0.1.3 from clarus-net`, `172.18.0.3 from docker_gwbridge`, `10.0.0.8 from ingress network`  )

16. Check the URLs of nodes that is not running the task with `http://<ec2-public-hostname-of-node>` in the browser and show that the app is not accessible.

17. Add following rules to security group of the nodes to enable the ingress network in the swarm and explain `swarm routing mesh`. *All nodes participate in an `ingress routing mesh`. The `routing mesh` enables each node in the `swarm` to accept connections on published ports for any service running in the swarm, **even if there’s no task running on the node**. The routing mesh routes all incoming requests to published ports on available nodes to an active container.* [Using swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/#bypass-the-routing-mesh)

  - For container network discovery -> Protocol: TCP,  Port: 7946, Source: security group itself

  - For container network discovery -> Protocol: UDP,  Port: 7946, Source: security group itself

  - For the container ingress network -> Protocol: UDP,  Port: 4789, Source: security group itself

18. Check the URLs of nodes that is not running the task with `http://<ec2-public-hostname-of-node>` in the browser and show that the app is **now** accessible.

19. Create a service for `clarusway/clarusdb` and connect it clarus-net.

```bash
docker service create --name clarus-db --network clarus-net clarusway/clarusdb
```

20. List services

```bash
docker service ls
```

21. List the tasks and go to terminal of ec2-instance which is running `clarus-db` task.

```bash
docker service ps clarus-db
```

22. List the containers in ec2-instance which is running `clarus-db` task.

```bash
docker container ls
```

23. Connect the `clarus-db` container.

```bash
docker container exec -it <container_id> sh
```

24. Ping the webserver service and explain DNS resolution. (When we ping the `Service Name`, it returns Virtual IP of `webserver`).

```bash
ping webserver
```

25. Explain the `load balancing` with the curl command. (Pay attention to the host when input `curl http://webserver` )

```bash
curl http://webserver
```

26. Remove the services.

```bash
docker service rm webserver clarus-db
```

## Part 4 - Managing Sensitive Data with Docker Secrets

27. Explain [how to manage sensitive data with Docker secrets](https://docs.docker.com/engine/swarm/secrets/).

28. Create two files named `name.txt` and `password.txt`.

```bash
echo "User" > name.txt
echo "clarus123@" > password.txt
```

29. Create docker secrets for both.

```bash
docker secret create username ./name.txt
docker secret create userpassword ./password.txt
```

30. List docker secrets.

```bash
docker secret ls
```

31. Create a new service with secrets.

```bash
docker service create -d --name secretdemo --secret username --secret userpassword clarusway/container-info:1.0
```

32. List the tasks and go to terminal of ec2-instance which is running `secretdemo` task.

```bash
docker service ps secretdemo
```

33. Connect the `secretdemo` container and show the secrets.

```bash
docker container exec -it <container_id> sh
cd /run/secrets
ls
cat username
cat userpassword
```

34. To update the secrets; create another secret using `standard input` and remove the old one.(We can't update the secrets.)

```bash
echo "qwert@123" | docker secret create newpassword -
docker service update --secret-rm userpassword --secret-add newpassword secretdemo
```

35. To check the updated secret, list the tasks and go to terminal of ec2-instance which is running `secretdemo` task.

```bash
docker service ps secretdemo
```

36. Connect the `secretdemo` container and show the secrets.

```bash
docker container exec -it <container_id> sh
cd /run/secrets
ls
cat newpassword
```

## Part 5 - Managing Docker Stack

37. Explain `Docker Stack`.

38. Create a folder for the project and change into your project directory
  
```bash
mkdir todoapi
cd todoapi
```

39. Create a file called `docker-compose.yml` in your project folder with following setup and explain it.

```yaml
version: "3.8"

services:
    database:
        image: mysql:5.7
        environment:
            MYSQL_ROOT_PASSWORD: R1234r
            MYSQL_DATABASE: todo_db
            MYSQL_USER: clarusway
            MYSQL_PASSWORD: Clarusway_1
        networks:
            - clarusnet
    myapp:
        image: clarusway/to-do-api:latest
        deploy:
            replicas: 5
        depends_on:
            - database
        ports:
            - "80:80"
        networks:
            - clarusnet

networks:
    clarusnet:
        driver: overlay
```

40. Deploy a new stack.

```bash
docker stack deploy -c ./docker-compose.yml clarus-todoapi
```

41. List stacks.

```bash
docker stack ls
```

42. List the services in the stack.

```bash
docker stack services clarus-todoapi
```

43. List the tasks in the stack

```bash
docker stack ps clarus-todoapi
```

44. Check if the `clarus-todoapi` is running by entering `http://<ec2-host-name>` in a browser.

- Remove stacks.

```bash
docker stack rm clarus-todoapi
```

## Part 6 - Running WordPress as a Docker Stack

45. Create a folder for the project and change into your project directory
  
```bash
mkdir wordpress
cd wordpress
```

46. Create a file called `wp_password.txt` containing a password in your project folder.

```bash
echo "Kk12345" > wp_password.txt
```

47. Create a file called `docker-compose.yml` in your project folder with following setup and explain it.

```yaml
version: "3.8"

services:
    wpdatabase:
        image: mysql:latest
        environment:
            MYSQL_ROOT_PASSWORD: R1234r
            MYSQL_DATABASE: claruswaywp
            MYSQL_USER: clarusway
            MYSQL_PASSWORD_FILE: /run/secrets/wp_password
        secrets:
            - wp_password
        networks:
            - clarusnet
    wpserver:
        image: wordpress:latest  
        depends_on:
            - wpdatabase
        deploy:
            replicas: 3
            update_config:
                parallelism: 2
                delay: 5s
                order: start-first
        environment:
            WORDPRESS_DB_USER: clarusway
            WORDPRESS_DB_PASSWORD_FILE: /run/secrets/wp_password
            WORDPRESS_DB_HOST: wpdatabase:3306
            WORDPRESS_DB_NAME: claruswaywp
        ports:
            - "80:80"
        secrets:
            - wp_password
        networks:
            - clarusnet
networks:
    clarusnet:
        driver: overlay

secrets:
    wp_password:
        file: wp_password.txt
```

48. Deploy a new stack.

```bash
docker stack deploy -c ./docker-compose.yml wpclarus
```

49. List stacks.

```bash
docker stack ls
```

50. List the services in the stack.

```bash
docker stack services wpclarus
```

51. List the tasks in the stack

```bash
docker stack ps wpclarus
```

52. Check if the `wordpress` is running by entering `http://<ec2-host-name>` in a browser.

53. Remove stacks.

```bash
docker stack rm wpclarus
```