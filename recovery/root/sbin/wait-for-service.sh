#!/sbin/sh

# wait-for-service.sh <init-service> <abstract-socket|-> <timeout-seconds>
#
# Require a service to remain running for several consecutive samples.  When
# an abstract socket is supplied, also require the kernel's listening flag
# (00010000); merely seeing a bound socket is not enough.

service_name="$1"
socket_name="$2"
timeout_seconds="$3"
samples=$((timeout_seconds * 10))
stable=0
i=0

while [ "$i" -lt "$samples" ]; do
    running=false
    socket_ready=false

    [ "$(getprop init.svc."$service_name")" = "running" ] && running=true
    if [ "$socket_name" = "-" ]; then
        socket_ready=true
    elif grep -q "00010000.*@$socket_name$" /proc/net/unix 2>/dev/null; then
        socket_ready=true
    fi

    if $running && $socket_ready; then
        stable=$((stable + 1))
        if [ "$stable" -ge 5 ]; then
            echo "$service_name ready"
            exit 0
        fi
    else
        stable=0
    fi

    sleep 0.1
    i=$((i + 1))
done

echo "$service_name readiness timeout" >&2
exit 1
