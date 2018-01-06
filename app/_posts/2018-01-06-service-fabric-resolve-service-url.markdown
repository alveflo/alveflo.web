---
layout: post
title:  "Service Fabric: Resolving endpoints"
categories: code
---

When building a micro-service architecture you're most likely
working with multiple internal services that obviously needs a
way to communicate with each other. In Azure Service Fabric you
can do this using 
[Service Fabric Reverse Proxy](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-reverseproxy)
or 
[ServicePartitionResolver](https://docs.microsoft.com/en-us/dotnet/api/microsoft.servicefabric.services.client.servicepartitionresolver?redirectedfrom=MSDN&view=azure-dotnet#microsoft_servicefabric_services_client_servicepartitionresolver).

The following article describes in short how to resolve a service endpoint adress using
ServicePartitionResolver.

Hmm but why can't we just hard code the address you might ask?
Well the problem is that if you hard code the endpoint, only one
instance of that service will be used. When you start scaling your
application you want to dynamically use different instances of the
same service (i.e. like load balancing).

```csharp
public async Task<string> ResolveEndpointAddress(
    string serviceName,
    CancellationToken cancellationToken)
{
    // Get the default service partition resolver
    var resolver = ServicePartitionResolver.GetDefault();
    // Resolve partition
    var servicePartition = await resolver.ResolveAsync(
            new Uri($"fabric:/MyApp/{serviceName}"),
            ServicePartitionKey.Singleton,
            cancellationToken);
    
    // Get endpoints for partition
    var endpoints = servicePartition
        .Endpoints
        .FirstOrDefault()?.Address;

    // Endpoints is returned as a JSON string,
    // so we'll need to parse that.
    var endpointsObj = JObject.Parse(endpoints);
    // Get the endpoint (length is always 1)
    var endpoint = (string) endpointsObj["Endpoints"].First();
    
    return endpoint;
}
```