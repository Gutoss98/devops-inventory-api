from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(
    prefix="/hosts",
    tags=["Hosts"]
)


class Host(BaseModel):
    hostname: str
    ip: str
    os: str


hosts = [
    Host(
        hostname="web01",
        ip="10.0.1.10",
        os="Rocky Linux 9"
    ),
    Host(
        hostname="db01",
        ip="10.0.1.20",
        os="Oracle Linux 9"
    ),
    Host(
        hostname="monitor01",
        ip="10.0.1.30",
        os="Ubuntu Server 24.04"
    )
]

@router.get("")
def get_hosts():
    return hosts


@router.post("")
def add_host(host: Host):
    hosts.append(host)
    return host


@router.delete("/{host_id}")
def delete_host(host_id: int):
    if host_id >= len(hosts):
        return {"message": "Host not found"}

    deleted = hosts.pop(host_id)

    return {
        "deleted": deleted
    }
