import React from 'react';
import { requireNativeComponent } from 'react-native';
const TICBridgeView = requireNativeComponent('TICBridgeView');
export default RCTTICBridgeView = React.forwardRef((props, ref) => {
    return <TICBridgeView ref={ref} style={props.styleBox} />;
});
