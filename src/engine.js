import React from 'react';
import { NativeModules, NativeEventEmitter } from 'react-native';

const TICBridgeManager = NativeModules.TICBridgeManager;
const RtcEngineEvent = new NativeEventEmitter(TICBridgeManager);
class WhiteBoardEngine {
    constructor() {}
    /**
     * 监听函数
     * @param {string} name - 监听的名字 目前只支持 borderviewReady, joinRoomSuccess, joinRoomError
     * @param {function} callback - 回调函数
     */
    addListener(name, callback) {
        RtcEngineEvent.addListener(name, e => {
            callback(e);
        });
    }
    /**
     * 清空全部监听函数
     * @param {string} name - 监听的名字 目前只支持 borderviewReady, joinRoomSuccess, joinRoomError
     * @param {function} callback - 回调函数
     */
    removeAllListener() {
        const keys = ['borderviewReady', 'joinRoomSuccess', 'joinRoomError'];
        for (const key of keys) {
            RtcEngineEvent.removeAllListeners(key);
        }
    }
    /**
     * 方法集合器
     * @param {string} name - 函数名称
     * @param {object} params - 参数的字典
     */
    async callMethod(name, params) {
        return await TICBridgeManager.callMethod(name, params);
    }
    /**
     * 解散群组,只有群主可以操作
     */
    async dismissGroup() {
        await TICBridgeManager.dismissGroup();
    }
    /**
     * 释放白板引擎
     */
    async unInitEngine() {
        await TICBridgeManager.unInitEngine();
    }
    /**
     * 初始化白板引擎, 后面传入宽高
     * @param {string} identifier -identifier
     * @param {object} info -info
     * @param {number} info.width -width
     * @param {number} info.height -height
     */
    async initEngine(identifier, info) {
        await TICBridgeManager.initEngine(identifier, info);
    }
    /**
     * 加入房间,房间的 uuid token由node后端来维护
     * @param {string} identifier -identifier
     */
    async joinRoom(roomUuid, roomToken) {
        await TICBridgeManager.joinRoom(roomUuid, roomToken);
    }
    /**
     * 设置白板工具
     * selector	选择工具
     * pencil	铅笔
     * rectangle	矩形绘制工具
     * ellipse	圆、椭圆绘制工具
     * eraser	橡皮，用于擦除其他教具绘制的笔迹
     * text	文字工具
     * straight	直线绘制工具
     * arrow	箭头绘制工具
     * laserPointer	激光笔工具
     * hand	抓手工具
     * @param {string} type
     */
    async setToolType(type) {
        return await TICBridgeManager.callMethod('setToolType', { type });
    }
    /**
     * 清空当前白板页涂鸦
     * @param {boolean} retainPPT - 是否同时清空ppt
     * @warning 目前不支持清除选中部分的同时清除背景
     */
    async clearBackground(retainPPT) {
        return await TICBridgeManager.callMethod('clearBackground', {
            retainPPT,
        });
    }
    /**
     * 设置刷子颜色
     * @param {string} color - 只支持rgb
     */
    async setBrushColor(color) {
        color = color
            .replace('rgb(', '')
            .replace(')', '')
            .split(',')
            .map(i => {
                return parseInt(i);
            });
        return await TICBridgeManager.callMethod('setBrushColor', { color });
    }
    /**
     * 设置刷子的粗细
     * @param {number} thin - 画笔的粗细
     */
    async setBrushThin(thin) {
        return await TICBridgeManager.callMethod('setBrushThin', { thin });
    }
    /**
     * 设置文本的颜色
     * @param {string} color - 只支持rgb 三位
     */
    async setTextColor(color) {
        color = color
            .replace('rgb(', '')
            .replace(')', '')
            .split(',')
            .map(i => {
                return parseInt(i);
            });
        return await TICBridgeManager.callMethod('setTextColor', { color });
    }
    /**
     * 设置文本的大小
     * @param {number} size - 文字的大小 float int 都可以.
     */
    async setTextSize(size) {
        return await TICBridgeManager.callMethod('setTextSize', { size });
    }
    /**
     * 撤销操作
     */
    async undo() {
        console.log('调用了没undo');
        return await TICBridgeManager.callMethod('undo', {});
    }
    /**
     * 重做操作
     */
    async redo() {
        console.log('调用了没redo');
        return await TICBridgeManager.callMethod('redo', {});
    }
    /**
     * 插入图片
     * @param {object} info - 网页或者图片的 url，只支持 https 协议的网址或者图片 url
     * @param {number} info.url - 元素类型，当设置 TEDU_BOARD_ELEMENT_IMAGE 时，等价于 addImageElement 方法
     * @param {number} info.width - 元素类型，当设置 TEDU_BOARD_ELEMENT_IMAGE 时，等价于 addImageElement 方法
     * @param {number} info.height - 元素类型，当设置 TEDU_BOARD_ELEMENT_IMAGE 时，等价于 addImageElement 方法
     */
    async insertImage(info) {
        info.uuid = info.name + Math.random();
        return await TICBridgeManager.callMethod('insertImage', info);
    }
    /**
     * 是否允许远端涂鸦
     * @param {boolean} enable - 是否允许涂鸦，true 表示白板可以涂鸦，false 表示白板不能涂鸦
     *
     */
    async setDrawEnable(enable) {
        return await TICBridgeManager.callMethod('setDrawEnable', { enable });
    }
    /**
     * 设置文本的颜色
     * @param {string} color - 只支持rgba, 四位
     */
    async setBackGround(color) {
        color = color
            .replace('rgba(', '')
            .replace(')', '')
            .split(',')
            .map(i => {
                return parseInt(i);
            });
        return await TICBridgeManager.callMethod('setBackGround', { color });
    }
    /**
     * 设置主播模式
     * freedom 代表自由模式, 默认模式
     * follower 代表追随模式
     * broadcaster 代表主播模式, 有一个人设置了主播模式,其他人都会变成追随者
     * @param {string} mode
     */
    async setViewMode(mode) {
        return await TICBridgeManager.setViewMode(mode);
    }
    /**
     * 禁用启用教具
     * @param {bool} disable
     */
    async disableDeviceInputs(disable) {
        return await TICBridgeManager.callMethod('disableDeviceInputs', { disable });
    }
    /**
     * 禁用启用所有手势
     * @param {bool} readonly
     */
    async disableOperations(readonly) {
        return await TICBridgeManager.callMethod('disableOperations', { readonly });
    }
}
export default new WhiteBoardEngine();
