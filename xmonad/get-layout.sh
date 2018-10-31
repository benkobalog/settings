#/bin/bash
isHu=$(xset -q | grep -A 0 'LED' | cut -c63-63)

if [ $isHu == 1 ]; then
    echo "HU"
else
    echo "US"
fi

exit 0
