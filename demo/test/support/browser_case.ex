defmodule DemoWeb.BrowserCase do
  @moduledoc """
  The case template of the end-to-end tests, ported from the Playwright suite
  in `assets/e2e`. Each module runs once per project of
  `assets/playwright.config.js`.
  """

  use ExUnit.CaseTemplate
  use Playwright.Test

  alias Playwright.Browser
  alias Playwright.BrowserContext
  alias Playwright.Test.BrowserPool

  @projects [
    %{
      project: "chromium",
      browser_name: :chromium,
      device: "Desktop Chrome",
      use: %{}
    },
    %{
      project: "chromium-reduced-motion",
      browser_name: :chromium,
      device: "Desktop Chrome",
      use: %{reduced_motion: :reduce}
    }
  ]

  def projects, do: @projects

  using do
    quote do
      use Playwright.Test

      import DemoWeb.E2EHelpers

      alias Playwright.{
        Browser,
        BrowserContext,
        Expect,
        Keyboard,
        Locator,
        Page
      }

      @moduletag :e2e
    end
  end

  setup_all %{browser_name: name} do
    %{browser: BrowserPool.browser(browser_name: name)}
  end

  setup %{browser: browser, device: device, use: use} do
    options =
      Map.merge(
        Map.fetch!(Playwright.devices(BrowserPool.playwright(browser)), device),
        use
      )

    context = Browser.new_context!(browser, options)
    %{context: context, page: BrowserContext.new_page!(context)}
  end
end
