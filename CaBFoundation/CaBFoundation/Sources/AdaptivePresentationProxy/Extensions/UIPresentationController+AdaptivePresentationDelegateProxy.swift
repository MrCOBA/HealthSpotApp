import UIKit

extension UIPresentationController {

    // MARK: - Public Methods

    public func setDismissHandlerDelegate(_ dismissDelegate: PresentationControllerDismissHandlerDelegate,
                                          using currentProxy: AdaptivePresentationDelegateProxy? = nil) -> AdaptivePresentationDelegateProxy {
        let proxy = configureProxy(using: currentProxy)
        proxy.dismissHandlerDelegate = dismissDelegate
        delegate = proxy

        return proxy
    }

    public func setPresentationDelegate(_ presentationDelegate: AdaptivePresentationControllerDelegate,
                                        using currentProxy: AdaptivePresentationDelegateProxy? = nil) -> AdaptivePresentationDelegateProxy {
        let proxy = configureProxy(using: currentProxy)
        proxy.adaptivePresentationDelegate = presentationDelegate
        delegate = proxy

        return proxy
    }

    // MARK: - Private Methods

    private func configureProxy(using currentProxy: AdaptivePresentationDelegateProxy? = nil) -> AdaptivePresentationDelegateProxy {
        let proxy: AdaptivePresentationDelegateProxy
        if delegate == nil {
            proxy = currentProxy ?? AdaptivePresentationDelegateProxyImpl()
        }
        else if let activeProxy = delegate as? AdaptivePresentationDelegateProxy {
            proxy = activeProxy
        }
        else {
            assertFailureUnexpectedDelegateType()
            proxy = currentProxy ?? AdaptivePresentationDelegateProxyImpl()
        }

        return proxy
    }

    // MARK: - Asserts

    private func assertFailureUnexpectedDelegateType(file: StaticString = #file, line: UInt = #line) {
        let message = "`delegate` is already set and doesn't conform to protocol `AdaptivePresentationDelegateProxy`: <\(String(describing: delegate))>. Must conform to it"
        logError(message: message)
    }

}
