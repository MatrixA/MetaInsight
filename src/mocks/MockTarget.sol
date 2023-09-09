contract MockTarget {
    function mockFunctionSuccess() external returns(bool) {
        return true;
    }

    function mockFunctionRevert() external returns(bool) {
        return true;
    }
}
